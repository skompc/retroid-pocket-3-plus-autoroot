import os
import struct

def main(args):
    if len(args) < 1:
        print("No input file")
        return

    meta_path = args[0]
    meta_dir = os.path.dirname(meta_path)

    with open(meta_path, "rb") as stream:
        # Search for 00 00 10 00 (int = 1048576)
        while True:
            if stream.tell() > os.path.getsize(meta_path) - 4:
                break
            req_value = struct.unpack("<i", stream.read(4))[0]
            if req_value == 1048576:
                # Search for name, take last 30 bytes and remove zero
                stream.seek(-34, os.SEEK_CUR)
                bytes_ = stream.read(30)
                if bytes_.count(0) > 10:
                    name = bytes_.replace(b"\x00", b"").decode("cp1252")
                    with open(os.path.join(meta_dir, f"{name}_key.bin"), "wb") as f:
                        f.write(stream.read(1032))
                else:
                    stream.seek(4, os.SEEK_CUR)
            else:
                stream.seek(-3, os.SEEK_CUR)

if __name__ == "__main__":
    import sys
    main(sys.argv[1:])
