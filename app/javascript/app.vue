<template>
  <v-app id="app">
    <MainPage />
  </v-app>
</template>

<script>
import MainPage from './components/MainPage.vue'

export default {
  name: 'App',
  components: {
    MainPage
  }
}
</script>

<style>
#app {
  background-color: #f8f5f2 !important;
}
img {
  object-fit: cover;
  border-radius: 50%;
}
</style>
