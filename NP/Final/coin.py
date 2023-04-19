import pprint

import requests
import json


_api = 'https://api.upbit.com/v1/candles/days?market=KRW-BTC&count=1'

j = requests.get(_api).content

pprint.pprint(j)
# df = pd.read_json(json.dumps(j), convert_dates=False,
#                   convert_axes=False).sort_values('timestamp', ascending=False)
# df.reset_index(drop=True, inplace=True)
# df['date'] = [OpenBlender.unixToDate(ts, timezone='GMT') for ts in df.timestamp]
# df = df.drop('timestamp', axis=1)