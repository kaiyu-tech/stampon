<template>
  <div v-if="user">
    <v-app-bar color="#078080">
      <v-toolbar-title>
        <img src="assets/title.svg" height="50" class="img__title" />
      </v-toolbar-title>

      <v-spacer></v-spacer>

      <span class="span__username-text">
        {{ user.name }}
      </span>

      <v-menu bottom offset-y rounded>
        <template #activator="{ on }">
          <v-btn icon v-on="on" class="v-btn__avatar">
            <img
              :src="avatars_url(user.discord_id, user.avatar)"
              width="40"
              height="40"
              class="img__icon"
              id="user-icon" />
          </v-btn>
        </template>

        <v-list>
          <v-list-item
            v-for="(item, i) in items"
            :key="i"
            @click="selectMenu(item)">
            <v-list-item-title v-text="item.text"></v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-app-bar>
    <v-main>
      <v-container>
        <div v-if="main">
          <MarksPage
            :marks="marks"
            :user="user"
            @edit-click="editMark"
            @delete-click="deleteMark"></MarksPage>
        </div>
        <div v-else>
          <MarkPage
            :mark="mark"
            :user="user"
            @update-click="updateMark"
            @cancel-click="cancel"></MarkPage>
        </div>
      </v-container>
    </v-main>
    <v-footer color="#078080" absolute>
      <div class="flex-grow-1"></div>
      <div>
        <span class="span__copyright-text">&copy; 2021 kaiyu-tech</span>
      </div>
    </v-footer>
  </div>
</template>

<script>
import axios from 'axios'
import MarksPage from './MarksPage.vue'
import MarkPage from './MarkPage.vue'
import common from '../packs/mixins/common.js'

export default {
  name: 'MainPage',
  mixins: [common],
  components: {
    MarksPage,
    MarkPage
  },
  data() {
    return {
      items: [{ text: 'ログアウト' }, { text: 'アカウント削除' }],
      main: true,
      user: null,
      marks: [],
      mark: null
    }
  },
  created() {
    history.pushState(null, null, null)
    window.addEventListener('popstate', function () {
      location.reload()
    })

    this.fetchMarks()
  },
  methods: {
    fetchMarks() {
      axios.get('/api/marks').then((res) => {
        this.user = res.data.user
        this.marks = res.data.marks
        this.main = true
      })
    },
    editMark(id) {
      axios.get(`/api/marks/${id}/edit`).then((res) => {
        this.mark = res.data.mark
        this.main = false
      })
    },
    updateMark(id, title, note) {
      axios
        .patch(`/api/marks/${id}`, {
          title: title,
          note: note
        })
        .then(() => this.fetchMarks())
    },
    deleteMark(id) {
      axios.delete(`/api/marks/${id}`).then(() => this.fetchMarks())
    },
    cancel() {
      this.main = true
    },
    async selectMenu(item) {
      switch (item.text) {
        case 'ログアウト':
          location.replace('/')
          break
        case 'アカウント削除':
          if (confirm('アカウントを削除しますか？')) {
            await axios.delete(`/api/users/${this.user.id}`)
            location.replace('/')
          }
          break
        default:
          return
      }
    }
  }
}
</script>
