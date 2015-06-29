from eventlet.corolocal import local
from werkzeug.local import LocalProxy
from werkzeug.wrappers import Request
from contextlib import contextmanager


import eventlet
from eventlet import wsgi

_requests = local()
request = LocalProxy(lambda: _requests.request)


@contextmanager
def sessionmanager(environ):
    _requests.request = Request(environ)
    yield
    _requests.request = None


def logic():
    return "Hello " + request.remote_addr


def application(environ, start_response):
    status = '200 OK'

    with sessionmanager(environ):
        body = logic()

    headers = [
        ('Content-Type', 'text/html')
    ]

    start_response(status, headers)
    return [body]


if __name__ == '__main__':
    print 'Serving on port 8000'
    wsgi.server(eventlet.listen(('', 8000)), application)
