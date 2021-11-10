<template>
  <div>
    <nav v-if="user">
      <img :src="avatars_url(user.id, user.avatar)" width="40" height="40" />
      {{ user.name }}
    </nav>
    <p />
    <div v-if="marks">
      <div v-if="main">
        <div v-if="marks.length > 0">
          <MarksPage
            :marks="marks"
            :user="user"
            @edit-click="editMark"
            @delete-click="deleteMark"></MarksPage>
        </div>
        <div v-else>まだデータがありません。</div>
      </div>
      <div v-else>
        <MarkPage
          :mark="mark"
          :user="user"
          @update-click="updateMark"
          @cancel-click="cancel"></MarkPage>
      </div>
    </div>
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
      main: true,
      user: null,
      marks: [],
      mark: null
    }
  },
  async created() {
    await this.fetchMarks()
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
    }
  }
}
</script>
