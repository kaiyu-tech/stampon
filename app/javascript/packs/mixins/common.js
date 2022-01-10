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
    },
    escapeHTML(text) {
      return text
        .replace(/&/g, '&lt;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#x27;')
        .replace(/`/g, '&#x60;')
    },
    replaceNewLine(text) {
      return text.replace(/(?:\r\n|\r|\n)/g, '<br />')
    },
    replaceUrl(text) {
      return text.replace(
        /(https?:\/\/[-_.!~*'()a-zA-Z0-9;/?:@&=+$,%#\u3000-\u30FE\u4E00-\u9FA0\uFF01-\uFFE3]+)/g,
        "<a href='$1' target='_blank'>$1</a>"
      )
    }
  }
}
