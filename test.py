from chll import create, merge

raw_data = [
    'eNrt0TENACAAA8GOTAQdqEQKAhCJA8JIwp2C5pukJn0FAACAk/nmrOKZ7zQJgIcMCQAAAAAAuLYBWvQCHQ==',
    'eNrt0FERABAAQLEXwAkipUBCauF8bBFWzVonAAAAAOCBoQCAj2wFAAAAwDMXioMBcQ==',
    'eNrt0DERgDAURMFj6CgQQoWESEHKF4RI2ggIpGBXwN3MS7Inxx1esw1ZKSEBAAB6pwQAdJbSAAAARlg/f2yiA/BDlwQzlQQTPQXRA0M=',
    'eNrt2bEJwCAARcEflJTiHM7ukLa2gYAIdyO89iVpyZgBAACqBAAAnzwSAFyqSHCNLgEAwO6VAOAvR/74AgjYAQc=',
    'eNrt0DENACAQALFL2BHy2hGJBdhbCa12zQkAAAAAAAAAAACAH0vBuwsy6wDo',
    'eNrt2CEBACEABMGjABnQn4ZIBCIkFvsSmImw4sQlqck3AwAA5ygSXKRLgD0CADjHkACAtzUJfvOeAFhTgM0CfdoB2Q==',
    'eNrt0sEJgDAQBMBVfAaxjrwsIaWlIIu0Ax+CEMlMBXu7l2RP6hWaCgAAgE+dP8u7dJsB8NqqAgAY0KECAOBJm+HIbYopi28GhnUDcbYCOA==',
    'eNrt0bENgDAUQ0GHpEQMkikzEEMyQRpE88XdBNZzkiuZd6CeQwIAgF9pEnxpSLB1SgAAUFOvPX95EAAAAGpotr33ABMZAX0=',
    'eNrtyjEBACAQAKFLYBCzfwijWUF3mKlW7QkAAAAAAAAAAAAA/pzXeAFOJAGl',
    'eNrt0AENACAQAKGbAQzy2Q1pDecgAtWuOcGHlgIAAAAAAAAAAAB4wgV/DADn',
]

for i, r in enumerate(raw_data):
    raw_data[i] = r.decode('base64').decode('zlib')

def do():
    counters = [create(r) for r in raw_data]
    result = merge(counters).cardinality()
    assert result == 46, result

if __name__ == '__main__':
    do()