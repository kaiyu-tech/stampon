<template>
  <ul>
    <li v-for="mark in marks" :key="mark.id">
      <a
        :href="
          channels_url(
            mark.discord.guild_id,
            mark.discord.channel_id,
            mark.discord.content_id,
            true
          )
        "
        target="_blank">
        <img src="assets/discord.png" width="20" height="20" />
      </a>
      |
      <a
        :href="
          channels_url(
            mark.discord.guild_id,
            mark.discord.channel_id,
            mark.discord.content_id,
            false
          )
        "
        target="_blank">
        <img src="assets/chrome.png" width="20" height="20" />
      </a>
      |
      <img
        :src="avatars_url(mark.author.id, mark.author.avatar)"
        width="20"
        height="20" />
      {{ mark.author.name }} | {{ mark.discord.content }} |
      <button @click="editClick(mark.id)">編集</button>
      <button @click="deleteClick(mark.id)">削除</button>
    </li>
  </ul>
</template>

<script>
import common from '../packs/mixins/common.js'

export default {
  name: 'MarksPage',
  mixins: [common],
  props: ['marks', 'user'],
  methods: {
    editClick(id) {
      this.$emit('edit-click', id)
    },
    deleteClick(id) {
      this.$emit('delete-click', id)
    }
  }
}
</script>
