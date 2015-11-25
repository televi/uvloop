cdef class UVTCPBase(UVStream):
    cdef:
        bint opened
        int flags

    cdef enable_nodelay(self)
    cdef disable_nodelay(self)


cdef class UVTCPServer(UVTCPBase):
    cdef:
        object protocol_factory

    cdef set_protocol_factory(self, object protocol_factory)

    cdef open(self, int sockfd)
    cdef bind(self, system.sockaddr* addr, unsigned int flags=*)

    cdef listen(self, int backlog=*)
    cdef _on_listen(self)

cdef class UVServerTransport(UVTCPBase):
    cdef:
        bint eof
        bint reading

        object protocol
        object protocol_data_received

        bint flow_control_enabled
        bint protocol_paused

        size_t high_water
        size_t low_water

    cdef _start_reading(self)
    cdef _stop_reading(self)

    cdef _on_read(self, bytes buf)
    cdef _on_eof(self)
    cdef _on_accept(self)
    cdef _on_write(self)

    cdef _write(self, object data, object callback)

    cdef inline size_t _get_write_buffer_size(self)
    cdef _set_write_buffer_limits(self, int high=*, int low=*)
    cdef _maybe_pause_protocol(self)
    cdef _maybe_resume_protocol(self)
