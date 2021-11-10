<template>
  <div>
    <div>
      <img
        :src="avatars_url(mark.author.id, mark.author.avatar)"
        width="20"
        height="20" />
      {{ mark.author.name }}
    </div>
    <div>title(option): <input v-model="title" placeholder="title" /></div>
    <div>content: {{ mark.discord.content }}</div>
    <div>note(option): <input v-model="note" placeholder="note" /></div>
    <button @click="updateClick">更新</button>
    <button @click="cancelClick">キャンセル</button>
  </div>
</template>

<script>
import common from '../packs/mixins/common.js'

export default {
  name: 'MarkPage',
  mixins: [common],
  props: ['mark', 'user'],
  data() {
    return {
      title: '',
      note: ''
    }
  },
  mounted() {
    this.title = this.mark.title
    this.note = this.mark.note
  },
  methods: {
    updateClick() {
      this.$emit('update-click', this.mark.id, this.title, this.note)
    },
    cancelClick() {
      this.$emit('cancel-click')
    }
  }
}
</script>
