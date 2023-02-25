import sys
import os
from StringIO import StringIO
from array import array
import struct

def main(args):
    if len(args) < 1:
        print ("No input file")
        return

    meta_path = args[0]
    meta_dir = os.path.dirname(meta_path)
    stream = StringIO(open(meta_path, 'rb').read())

    # Search for 00 00 10 00 (int = 1048576)
    while True:
        if stream.tell() > stream.len - 4:
            break

        req_value = struct.unpack("<i", stream.read(4))[0]
        if req_value == 1048576:
            #Search for name, take last 30 bytes and remove zero
            stream.seek(-34, os.SEEK_CUR)
            bytes = array('B', stream.read(30))
            if bytes.count(0) > 10:
                name = bytes.tostring().decode('utf-8').replace('\x00','')
                open(os.path.join(meta_dir, "{}_key.bin".format(name)), 'wb').write(stream.read(1032))
            else:
                stream.seek(4, os.SEEK_CUR)
        else:
            stream.seek(-3, os.SEEK_CUR)

if __name__ == "__main__":
    main(sys.argv[1:])
