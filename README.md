# CryptoList

This app uses the following endpoint as requested: https://github.com/kenechiokolo/CryptoList.git.

Note that this api returns cryptocurrencies in their INR prices, and not USD or SEK as specified by the instructions.
Consequently, INR prices have been excluded from the app, and USDT (a cryptocurrency tethered to the value of USD) has been
used to determine the base price for the currencies listed. To get the price in SEK, exchange rates are fetched from the
following endpoint: https://api.exchangerate.host/latest?base=USD, using USD as the base currency and then converetd in order
to give their value in SEK.

The app also doesn't list all the currencies returned by the API - only the first ten as the user's initial 'favourites'. These
favourites can be edited by the user using swipe actions and they persist between launches using User Defaults.

Not that the app requires an internet connection to fetch any data, and that previously returned rates are not saved.

Screenshot from App:
![Simulator Screen Shot - iPhone 14 Pro Max - 2023-01-15 at 18 09 49](https://user-images.githubusercontent.com/11274830/212559063-d782e683-ef18-430b-82bc-adebb911c0fd.png)
