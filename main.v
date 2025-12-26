module main

import uv {
    stream_handle,
    tcp_handle,
    tcp_stream
    sockaddr,

    RunMode
}


__global (
    loop &uv.Loop
)


fn alloc(handle &uv.Handle, size usize, buf &uv.Buf) {
    unsafe { *buf = uv.buf_init(malloc(size), size) }
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
            uv.close(stream_handle(client), voidptr(0)) 
        }
    } else if nread > 0 {
        req := &uv.Write{};
        wrbuf := uv.buf_init(buf.base, usize(nread))
        uv.write(req, client, &wrbuf, 1, write)
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
    uv.tcp_init(loop, client);

    out_stream := tcp_stream(client)

    if uv.accept(server, out_stream) == 0 {
        uv.read_start(out_stream, alloc, read)
    } else {
        uv.close(tcp_handle(client), C.NULL);
    }
}

fn main() {
    mut server := &uv.TCP{}
    mut addr := &uv.SockaddrIn{}

    loop = uv.default_loop()
    uv.tcp_init(loop, server)
    uv.ip4_addr('0.0.0.0', 7000, addr)
    uv.tcp_bind(server, sockaddr(addr), 0)

    r := uv.listen(tcp_stream(server), 128, on_connection)
    if r > 0 {
        eprintln("Listen error ${r}")
        return
    }

    res := uv.run(loop, RunMode.default)
    println("${res}")
}