<template>
  <div></div>
</template>
<script>
export default {
  data () {
    return {
      userlist: []
    }
  },
  methods: {
    getAllUsers: async function () {
      this.userlist = await this.$http.get('/api/user')
      console.log('create')
    }
  },
  created () {
    this.getAllUsers()
  }
}
</script>
<style lang="less" scoped>

</style>
