<template>
  <v-container>
    <v-row justify="center">
      <v-col>
        <v-card>
          <v-card-title>
            <v-text-field
              v-model="search"
              append-icon="mdi-magnify"
              label="Search"></v-text-field>
          </v-card-title>
          <v-data-table
            :headers="headers"
            :items="items"
            :search="search"
            :footer-props="{
              'items-per-page-options': [15, 50, 100, -1]
            }"
            no-data-text="まだデータがありません😢！Discordでブックマーク発言したい発言に「気になる」か「👀」スタンプを押そう！">
            <template #[`item.name`]="{ item }">
              <v-tooltip open-delay="150" bottom>
                <template v-slot:activator="{ on, attrs }">
                  <img
                    :src="item.avatars_url"
                    width="30"
                    height="30"
                    class="img__icon img__avatar"
                    v-bind="attrs"
                    v-on="on" />
                </template>
                <span>{{ item.name }}</span>
              </v-tooltip>
            </template>
            <template #[`item.text`]="{ item }">
              <v-tooltip open-delay="150" bottom>
                <template v-slot:activator="{ on, attrs }">
                  <div
                    @click="editClick(item)"
                    class="div__text-link"
                    v-bind="attrs"
                    v-on="on">
                    {{
                      item.text.slice(0, 50) +
                      (item.text.length > 50 ? '...' : '')
                    }}
                  </div>
                </template>
                <div v-html="replaceNewLine(escapeHTML(item.text))"></div>
              </v-tooltip>
            </template>
            <template #[`item.detail`]="{ item }">
              <div @click="editClick(item)" class="div__text-link">
                <v-tooltip open-delay="150" bottom>
                  <template v-slot:activator="{ on, attrs }">
                    <v-icon v-bind="attrs" v-on="on">
                      mdi-note-text-outline
                    </v-icon>
                  </template>
                  <span>詳細を表示</span>
                </v-tooltip>
              </div>
            </template>
            <template #[`item.channels_url`]="{ item }">
              <v-tooltip open-delay="150" bottom>
                <template v-slot:activator="{ on, attrs }">
                  <v-btn
                    icon
                    :href="item.channels_url"
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
                    :href="item.discord_url"
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
            </template>
            <template #[`item.delete`]="{ item }">
              <v-btn
                small
                outlined
                color="error"
                @click.stop="deleteClick(item)">
                削除
              </v-btn>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import common from '../packs/mixins/common.js'

export default {
  name: 'MarksPage',
  mixins: [common],
  props: ['marks', 'user'],
  data() {
    return {
      search: '',
      headers: [
        {
          text: '投稿者',
          value: 'name',
          width: '8%'
        },
        {
          text: '概要',
          value: 'text'
        },
        {
          text: '詳細',
          sortable: false,
          value: 'detail'
        },
        {
          text: 'リンク',
          value: 'channels_url',
          sortable: false,
          width: '12%'
        },
        {
          text: '投稿日時',
          value: 'wrote_at',
          width: '15%'
        },
        {
          text: '',
          value: 'delete',
          sortable: false,
          width: '8%'
        }
      ],
      items: []
    }
  },
  mounted() {
    this.items = this.marks.map((mark) => {
      return {
        id: mark.id,
        channels_url: this.channels_url(
          mark.discord.guild_id,
          mark.discord.channel_id,
          mark.discord.content_id,
          false
        ),
        discord_url: this.channels_url(
          mark.discord.guild_id,
          mark.discord.channel_id,
          mark.discord.content_id,
          true
        ),
        avatars_url: this.avatars_url(mark.author.id, mark.author.avatar),
        name: mark.author.display_name,
        text: mark.title ? mark.title : mark.discord.content,
        wrote_at: mark.discord.wrote_at
      }
    })
  },
  methods: {
    editClick(item) {
      this.$emit('edit-click', item.id)
    },
    deleteClick(item) {
      if (confirm('選択したデータを削除しますか？')) {
        this.$emit('delete-click', item.id)
        this.items.splice(this.items.indexOf(item), 1)
      }
    }
  }
}
</script>

<style scoped>
.v-data-table {
  word-break: break-all;
}
</style>
