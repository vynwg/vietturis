module uv


@[typedef]
struct C.uv_loop_t {}
@[typedef]
struct C.uv_tcp_t {}
@[typedef]
struct C.uv_stream_t {}
@[typedef]
struct C.uv_handle_t {}
@[typedef]
struct C.uv_write_t {}
@[typedef]
struct C.uv_buf_t {
	base &char
}

struct C.sockaddr_in {}
struct C.sockaddr {}


pub enum RunMode as u8 {
	default = C.UV_RUN_DEFAULT
  	once    = C.UV_RUN_ONCE
  	nowait  = C.UV_RUN_NOWAIT
}

pub type Loop       = C.uv_loop_t
pub type TCP        = C.uv_tcp_t
pub type Stream     = C.uv_stream_t
pub type Handle     = C.uv_handle_t
pub type Write      = C.uv_write_t
pub type Buf        = C.uv_buf_t
pub type SockaddrIn = C.sockaddr_in
pub type Sockaddr   = C.sockaddr

pub type ReadCb     = fn (&Stream, isize, &Buf)
pub type AllocCb    = fn (&Handle, usize, &Buf)
pub type NewConnCb  = fn (&Stream, i32)
pub type WriteCb    = fn (&Write , i32)
pub type CloseCb    = fn (&Handle)

pub const eof       = C.UV_EOF
