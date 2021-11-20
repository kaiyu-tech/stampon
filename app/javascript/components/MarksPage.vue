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
            <template #item.channels_url="{ item }">
              <a :href="item.channels_url" target="_blank">
                <img src="assets/chrome.png" width="30" height="30" />
              </a>
              <a :href="item.discord_url" target="_blank">
                <img src="assets/discord.png" width="30" height="30" />
              </a>
            </template>
            <template #item.name="{ item }">
              <img :src="item.avatars_url" width="30" height="30" />
              {{ item.name }}
            </template>
            <template #item.delete="{ item }">
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
          sortable: false
        },
        {
          text: '名前',
          value: 'name'
        },
        {
          text: '内容',
          value: 'content'
        },
        {
          text: '',
          value: 'delete',
          sortable: false
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
          true
        ),
        discord_url: this.channels_url(
          mark.discord.guild_id,
          mark.discord.channel_id,
          mark.discord.content_id,
          true
        ),
        avatars_url: this.avatars_url(mark.author.id, mark.author.avatar),
        name: mark.author.display_name,
        content:
          mark.discord.content.slice(0, 50) +
          (mark.discord.content.length > 50 ? '...' : '')
      }
    })
  },
  methods: {
    editClick(item) {
      this.$emit('edit-click', item.id)
    },
    deleteClick(item) {
      if (confirm('削除しますか')) {
        this.$emit('delete-click', item.id)
        this.items.splice(this.items.indexOf(item), 1)
      }
    }
  }
}
</script>

<style>
.v-main {
  margin-bottom: 30px !important;
}
.v-data-table {
  cursor: pointer !important;
}
</style>
