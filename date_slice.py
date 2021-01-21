import datetime

monthago = datetime.datetime.now() - datetime.timedelta(days=30)
now = datetime.datetime.now() - datetime.timedelta(days=0)
millisec = now.timestamp()*1000

now_ms = now.timestamp() * 1000
diff_ms = (now.timestamp() - monthago.timestamp())*1000

restored = datetime.datetime.fromtimestamp(millisec/1000.0)

print(now)
print(restored)

for x in range (100):
    date_ms = (now_ms + x * diff_ms/100)
    print(datetime.datetime.fromtimestamp(date_ms/1000.0))
    # print datetime.datetime.fromtimestamp(date_ms/1000.0)

# from datetime import datetime, time as datetime_time, timedelta

# def time_diff(start, end):
#     if isinstance(start, datetime_time): # convert to datetime
#         assert isinstance(end, datetime_time)
#         start, end = [datetime.combine(datetime.min, t) for t in [start, end]]
#     if start <= end: # e.g., 10:33:26-11:15:49
#         return end - start
#     else: # end < start e.g., 23:55:00-00:25:00
#         end += timedelta(1) # +day
#         assert end > start
#         return end - start

# for time_range in ['10:33:26-11:15:49', '23:55:00-00:25:00']:
#     s, e = [datetime.strptime(t, '%H:%M:%S') for t in time_range.split('-')]
#     print(time_diff(s, e))
#     assert time_diff(s, e) == time_diff(s.time(), e.time())