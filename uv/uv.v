module uv

import uv.c as _

pub fn strerror(status i32) string {
    p_str := C.uv_strerror(status)

    if p_str != 0 {
        return unsafe { cstring_to_vstring(p_str) }
    }

    return ""
}

pub fn err_name(status isize) string {
    p_str := C.uv_err_name(status)

    if p_str != 0 {
        return unsafe { cstring_to_vstring(p_str) }
    }

    return ""
}

pub fn default_loop() &Loop {
    return C.uv_default_loop()
}

pub fn tcp_init(loop &Loop, tcp &TCP) i32 {
    return C.uv_tcp_init(loop, tcp)
}

pub fn ip4_addr(host string, port i32, addr &SockaddrIn) i32 {
    return C.uv_ip4_addr(&char(host.str), port, addr)
}

pub fn run(loop &Loop, mode RunMode) i32 {
    return C.uv_run(loop, mode)
}

pub fn tcp_bind(tcp &TCP, addr &Sockaddr, port u32) i32 {
  return C.uv_tcp_bind(tcp, addr, port)  
}

pub fn listen(stream &Stream, backlog i32, cb NewConnCb) i32 {
    return C.uv_listen(stream, backlog, cb)
}

pub fn accept(server &Stream, client &Stream) i32 {
    return C.uv_accept(server, client)
}

pub fn read_start(stream &Stream, alloc AllocCb, read ReadCb) i32 {
    return C.uv_read_start(stream, alloc, read)
}

pub fn close(handle &Handle, cb CloseCb) {
    C.uv_close(handle, cb)
}

pub fn buf_init(p_base &char, size usize) Buf {
    return C.uv_buf_init(p_base, size)
}

pub fn write(wrt &Write, stream &Stream, buf &Buf, n u32, cb WriteCb) i32 {
    return C.uv_write(wrt, stream, buf, n, cb)
}
