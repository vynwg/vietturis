module main

import uv {
    stream_handle,
    tcp_handle,
    tcp_stream
    sockaddr,
}


__global (
    loop &uv.Loop
)


fn alloc(handle &uv.Handle, size usize, buf &uv.Buf) {
    unsafe { *buf = C.uv_buf_init(malloc(size), size) }
}

fn write(req &uv.Write, status i32) {
    if status != 0 {
        eprintln("Write error ${uv.strerror(status)}")
    }
    if req != 0 {
        unsafe { free(req) }
    }
}

fn read(client &uv.Stream, nread isize, buf &uv.Buf) {
    if nread < 0 {
        if nread != uv.eof {
            eprintln("Read error ${uv.err_name(nread)}")
            C.uv_close(stream_handle(client), C.NULL) 
        }
    } else if nread > 0 {
        req := &uv.Write{};
        wrbuf := C.uv_buf_init(buf.base, nread)
        C.uv_write(req, client, &wrbuf, 1, write)
    }

    if buf.base != 0 {
        unsafe { free(buf.base) }
    }
}

fn on_connection(server &uv.Stream, status i32) {
    if status < 0 {
        eprintln("New connection error ${uv.strerror(status)}")
        return
    }

    client := &uv.TCP{}
    C.uv_tcp_init(loop, client);

    out_stream := tcp_stream(client)

    if C.uv_accept(server, out_stream) == 0 {
        C.uv_read_start(out_stream, alloc, read)
    } else {
        C.uv_close(tcp_handle(client), C.NULL);
    }
}

fn main() {
    mut server := &uv.TCP{}
    mut addr := &uv.SockaddrIn{}

    loop = C.uv_default_loop()
    C.uv_tcp_init(loop, server)
    C.uv_ip4_addr(c'0.0.0.0', 7000, addr)
    C.uv_tcp_bind(server, sockaddr(addr), 0)

    r := C.uv_listen(tcp_stream(server), 128, on_connection)
    if r > 0 {
        eprintln("Listen error ${r}")
        return
    }

    res := C.uv_run(loop, 0)
    println("${res}")
}