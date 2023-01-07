# LibIsClassic-1.0

A small embeddable library to detect if you're on Retail or Classic servers.

[![Version](https://img.shields.io/github/v/tag/ravendwyr/libisclassic-1.0?label=Version&logo=curseforge&style=flat-square)](https://www.curseforge.com/wow/addons/libisclassic-1.0/files/all)
[![Tracker](https://img.shields.io/github/issues/ravendwyr/libisclassic-1.0?label=Issues&logo=github&style=flat-square)](https://github.com/Ravendwyr/LibIsClassic-1.0/issues)

***

## The Quick Intro

This library is designed to be directly embedded into your addon.

Ace3 method:

    MyAddon = LibStub("AceAddon-3.0"):NewAddon("MyAddon", "LibIsClassic-1.0")

Non-Ace3 method:

    local _, MyAddon = ...
    MyAddon = LibStub("LibIsClassic-1.0"):Embed(MyAddon)

Standalone method (no embedding):

    local LIC = LibStub("LibIsClassic-1.0")

This library provides a few functions for your addon to use. These functions are self-explanatory:

* `MyAddon:IsRetail()` - returns `true` on modern retail servers and `false` on other servers
* `MyAddon:IsClassic()` - returns `true` on Classic Era (1.13.x) servers and `false` on other servers
* `MyAddon:IsBurningCrusadeClassic()` - returns `true` on Burning Crusade Classic (2.5.x) servers and `false` on other servers

## Example

```
if self:IsRetail() then
    -- do stuff that doesn't apply to 1.13.x or 2.5.x
end

if not self:IsBurningCrusadeClassic() then
    -- do stuff that only applies to 1.13.x and retail
end
```

***

### Support

[![Twitter](https://img.shields.io/twitter/follow/ravendwyr?label=Twitter&logo=twitter&style=flat-square)](https://twitter.com/Ravendwyr)
[![Discord](https://img.shields.io/discord/299308204393889802?label=Discord&logo=discord&style=flat-square)](https://top.gg/servers/299308204393889802)
[![Sponsor](https://img.shields.io/github/sponsors/ravendwyr?label=Sponsors&logo=github+sponsors&style=flat-square)](https://github.com/sponsors/Ravendwyr)

[![Twitch](https://img.shields.io/badge/Twitch-subscribe-yellow?&logo=twitch&style=flat-square)](https://www.twitch.tv/subs/ravendwyr)
[![Crypto](https://img.shields.io/badge/ETH-send-yellow?&logo=ethereum&style=flat-square)](https://etherscan.io/address/0x332224Ed82264298B3DC68dAcf643E8Df4abDCC3)
[![PayPal](https://img.shields.io/badge/PayPal-donate-yellow?logo=paypal&style=flat-square)](https://www.paypal.me/Ravendwyr/5gbp)
[![Coffee](https://img.shields.io/badge/Kofi-buy-yellow?logo=ko-fi&style=flat-square)](https://ko-fi.com/Ravendwyr)
