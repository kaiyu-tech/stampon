<template>
  <v-row justify="center">
    <v-col>
      <v-card>
        <v-card-title>
          <v-container>
            <v-row>
              <v-col cols="10">
                <img
                  :src="avatars_url(mark.author.id, mark.author.avatar)"
                  width="50"
                  height="50"
                  class="img__icon img__avatar" />
                <span class="span__avatar-text"
                  >{{ mark.author.display_name }} (投稿日時:
                  {{ mark.discord.wrote_at }})</span
                >
              </v-col>
              <v-col cols="2" align="right">
                <v-tooltip open-delay="150" bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn
                      icon
                      :href="
                        channels_url(
                          mark.discord.guild_id,
                          mark.discord.channel_id,
                          mark.discord.content_id,
                          false
                        )
                      "
                      target="_blank"
                      @click.stop
                      class="v-btn__link"
                      v-bind="attrs"
                      v-on="on">
                      <img
                        src="assets/chrome.png"
                        width="30"
                        height="30"
                        class="img__icon" />
                    </v-btn>
                  </template>
                  <span>ブラウザで開く</span>
                </v-tooltip>
                <v-tooltip open-delay="150" bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-btn
                      icon
                      :href="
                        channels_url(
                          mark.discord.guild_id,
                          mark.discord.channel_id,
                          mark.discord.content_id,
                          true
                        )
                      "
                      target="_blank"
                      @click.stop
                      class="v-btn__link"
                      v-bind="attrs"
                      v-on="on">
                      <img
                        src="assets/discord.png"
                        width="30"
                        height="30"
                        class="img__icon" />
                    </v-btn>
                  </template>
                  <span>Discord Appで開く</span>
                </v-tooltip>
              </v-col>
            </v-row>
          </v-container>
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
          <v-btn outlined color="#f45d48" @click="cancelClick">
            キャンセル
          </v-btn>
          <v-spacer></v-spacer>
          <v-btn color="#078080" @click="updateClick" class="white--text">
            更新
          </v-btn>
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
