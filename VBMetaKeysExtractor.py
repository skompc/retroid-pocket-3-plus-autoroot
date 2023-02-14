import sys
import os
from io import BytesIO
from array import array

def main(args):
    if len(args) < 1:
        print("No input file")
        return

    meta_path = args[0]
    meta_dir = os.path.dirname(meta_path)
    stream = BytesIO(open(meta_path, 'rb').read())

    # Search for 00 00 10 00 (int = 1048576)
    while True:
        if stream.tell() > stream.getbuffer().nbytes - 4:
            break

        req_value = int.from_bytes(stream.read(4), byteorder='little')
        if req_value == 1048576:
            #Search for name, take last 30 bytes and remove zero
            stream.seek(-34, os.SEEK_CUR)
            bytes = array('B', stream.read(30))
            if bytes.count(0) > 10:
                name = bytes.tobytes().decode('utf-8').replace('\x00','')
                open(os.path.join(meta_dir, f"{name}_key.bin"), 'wb').write(stream.read(1032))
            else:
                stream.seek(4, os.SEEK_CUR)
        else:
            stream.seek(-3, os.SEEK_CUR)

if __name__ == "__main__":
    main(sys.argv[1:])
