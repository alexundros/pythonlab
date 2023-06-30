import time


if __name__ == '__main__':
    try:
        start = time.time()
        total = 0
        for i in range(1, 10000):
            for j in range(1, 10000):
                total += i + j
        print(f"The result is {total}")
        print(f"Time {time.time() - start:.2f} sec.")
    except Exception as ex:
        print(ex)
    try:
        input('Press any key to exit\n')
    except KeyboardInterrupt:
        pass
