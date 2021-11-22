<template>
  <v-row justify="center">
    <v-col>
      <v-card>
        <v-card-title>
          <img
            :src="avatars_url(mark.author.id, mark.author.avatar)"
            width="50"
            height="50"
            class="img__icon img__avatar" />
          {{ mark.author.display_name }}
        </v-card-title>
        <v-card-text>
          <v-text-field v-model="title" label="タイトル(任意)"></v-text-field>
          <v-textarea
            v-model="content"
            label="内容"
            filled
            readonly></v-textarea>
          <v-textarea v-model="note" label="ノート(任意)"></v-textarea>
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-btn color="error" @click="cancelClick"> キャンセル </v-btn>
          <v-spacer></v-spacer>
          <v-btn color="primary" @click="updateClick"> 更新 </v-btn>
        </v-card-actions>
      </v-card>
    </v-col>
  </v-row>
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
      content: '',
      note: ''
    }
  },
  mounted() {
    this.title = this.mark.title
    this.content = this.mark.discord.content
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
