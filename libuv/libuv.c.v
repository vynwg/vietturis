module libuv

#flag -L /usr/lib/
#flag -luv

#include <uv.h>


@[typedef]
pub struct C.uv_loop_t {}
@[typedef]
pub struct C.uv_tcp_t {}
@[typedef]
pub struct C.uv_stream_t {}
@[typedef]
pub struct C.uv_handle_t {}
@[typedef]
pub struct C.uv_write_t {}
@[typedef]
pub struct C.uv_buf_t {
	base &char
}

pub struct C.sockaddr_in {}
pub struct C.sockaddr {}


pub type ReadCb    = fn (&C.uv_stream_t, isize, &C.uv_buf_t)
pub type AllocCb   = fn (&C.uv_handle_t, usize, &C.uv_buf_t)
pub type CloseCb   = fn (&C.uv_handle_t)
pub type WriteCb   = fn (&C.uv_write_t, i32)
pub type NewConnCb = fn (&C.uv_stream_t, i32)

fn C.uv_default_loop() &C.uv_loop_t
fn C.uv_tcp_init(&C.uv_loop_t, &C.uv_tcp_t) i32
fn C.uv_ip4_addr(&char, i32, &C.sockaddr_in) i32
fn C.uv_run(&C.uv_loop_t, u8) i32
fn C.uv_tcp_bind(&C.uv_tcp_t, &C.sockaddr, u32) i32
fn C.uv_listen(&C.uv_stream_t, i32, NewConnCb) i32
fn C.uv_accept(&C.uv_stream_t, &C.uv_stream_t) i32
fn C.uv_read_start(&C.uv_stream_t, AllocCb, ReadCb) i32
fn C.uv_close(&C.uv_handle_t, CloseCb)
fn C.uv_buf_init(&char, u32) C.uv_buf_t
fn C.uv_write(&C.uv_write_t, &C.uv_stream_t, &C.uv_buf_t, u32, WriteCb) i32
fn C.uv_strerror(i32) &char
fn C.uv_err_name(i32) &char


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

