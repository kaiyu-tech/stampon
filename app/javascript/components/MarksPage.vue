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
            @click:row="editClick">
            <template #[`item.channels_url`]="{ item }">
              <v-btn
                icon
                :href="item.channels_url"
                target="_blank"
                @click.stop
                class="v-btn__link">
                <img src="assets/chrome.png" width="30" height="30" />
              </v-btn>
              <v-btn
                icon
                :href="item.discord_url"
                target="_blank"
                @click.stop
                class="v-btn__link">
                <img src="assets/discord.png" width="30" height="30" />
              </v-btn>
            </template>
            <template #[`item.name`]="{ item }">
              <img :src="item.avatars_url" width="30" height="30" />
              {{ item.name }}
            </template>
            <template #[`item.text`]="{ item }">
              {{
                item.text.slice(0, 50) + (item.text.length > 50 ? '...' : '')
              }}
            </template>
            <template #[`item.delete`]="{ item }">
              <v-btn small color="error" @click.stop="deleteClick(item)">
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
          text: 'リンク',
          value: 'channels_url',
          sortable: false,
          width: '12%'
        },
        {
          text: '投稿者',
          value: 'name',
          width: '18%'
        },
        {
          text: '概要',
          value: 'text'
        },
        {
          text: '投稿日時',
          value: 'wrote_at',
          width: '10%'
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
