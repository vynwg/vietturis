module uv

fn C.uv_default_loop() &Loop
fn C.uv_tcp_init(&Loop, &TCP) i32
fn C.uv_ip4_addr(&char, i32, &SockaddrIn) i32
fn C.uv_run(&Loop, u8) i32
fn C.uv_tcp_bind(&TCP, &Sockaddr, u32) i32
fn C.uv_listen(&Stream, i32, NewConnCb) i32
fn C.uv_accept(&Stream, &Stream) i32
fn C.uv_read_start(&Stream, AllocCb, ReadCb) i32
fn C.uv_close(&Handle, CloseCb)
fn C.uv_buf_init(&char, u32) Buf
fn C.uv_write(&Write, &Stream, &Buf, u32, WriteCb) i32
fn C.uv_strerror(i32) &char
fn C.uv_err_name(i32) &char
