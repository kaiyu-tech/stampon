export default {
  data() {
    return {
      scheme: ''
    }
  },
  created() {
    const ua = window.navigator.userAgent.toLowerCase()
    if (ua.indexOf('iphone') !== -1 || ua.indexOf('ipad') !== -1) {
      this.scheme = 'com.hammerandchisel.discord://'
    } else if (ua.indexOf('android') !== -1) {
      this.scheme = 'android-app://com.discord/https/'
    } else {
      // windows, mac
      this.scheme = 'discord://'
    }
  },
  methods: {
    avatars_url(id, avatar) {
      return `https://cdn.discordapp.com/avatars/${id}/${avatar}.png`
    },
    channels_url(guild_id, channel_id, content_id, app) {
      let scheme = 'https://'
      if (app == true) scheme = this.scheme
      return `${scheme}discord.com/channels/${guild_id}/${channel_id}/${content_id}`
    }
  }
}
