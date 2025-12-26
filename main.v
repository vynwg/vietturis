module main

import libuv {
    strerror,
    err_name
}


__global (
    loop &C.uv_loop_t
)


fn alloc(handle &C.uv_handle_t, size usize, buf &C.uv_buf_t) {
    unsafe { *buf = C.uv_buf_init(malloc(size), size) }
}

fn write(req &C.uv_write_t, status i32) {
    if status != 0 {
        eprintln("Write error ${strerror(status)}")
    }
    if req != 0 {
        unsafe { free(req) }
    }
}

fn read(client &C.uv_stream_t, nread isize, buf &C.uv_buf_t) {
    if nread < 0 {
        if nread != C.UV_EOF {
            eprintln("Read error ${err_name(nread)}")
            C.uv_close(&C.uv_handle_t(client), C.NULL)
        }
    } else if nread > 0 {
        req := &C.uv_write_t{};
        wrbuf := C.uv_buf_init(buf.base, nread)
        C.uv_write(req, client, &wrbuf, 1, write)
    }

    if buf.base != 0 {
        unsafe { free(buf.base) }
    }
}

fn on_connection(server &C.uv_stream_t, status i32) {
    if status < 0 {
        eprintln("New connection error ${strerror(status)}")
        return
    }

    client := &C.uv_tcp_t{}
    C.uv_tcp_init(loop, client);

    out_stream := &C.uv_stream_t(client)

    if C.uv_accept(server, out_stream) == 0 {
        C.uv_read_start(out_stream, alloc, read)
    } else {
        C.uv_close(&C.uv_handle_t(client), C.NULL);
    }
}

fn main() {
    mut server := &C.uv_tcp_t{}
    mut addr := &C.sockaddr_in{}

    loop = C.uv_default_loop()
    C.uv_tcp_init(loop, server)
    C.uv_ip4_addr(c'0.0.0.0', 7000, addr)
    C.uv_tcp_bind(server, &C.sockaddr(addr), 0)

    r := C.uv_listen(&C.uv_stream_t(server), 128, on_connection)
    if r > 0 {
        eprintln("Listen error ${r}")
        return
    }

    res := C.uv_run(loop, 0)
    println("${res}")
}