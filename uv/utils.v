module uv


pub fn stream_handle(s &Stream) &Handle {
	return unsafe { &Handle(s) }
}

pub fn tcp_handle(t &TCP) &Handle {
	return unsafe { &Handle(t) }
}

pub fn tcp_stream(t &TCP) &Stream {
	return unsafe { &Stream(t) }
}

pub fn sockaddr(s &SockaddrIn) &Sockaddr {
	return unsafe { &Sockaddr(s) }
}
