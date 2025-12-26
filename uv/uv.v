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
