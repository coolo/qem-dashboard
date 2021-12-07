<template>
  <div id="app">
    <nav class="navbar navbar-expand-lg navbar-light bg-light mb-3 border-bottom">
      <div class="container-fluid">
        <router-link :to="{name: 'home'}" exact class="navbar-brand">
          <i class="fab fa-suse" style="color: green"></i>
          <i class="fas fa-vial" style="color: purple"></i>
        </router-link>
        <button
          class="navbar-toggler"
          type="button"
          data-toggle="collapse"
          data-target="#navbarSupportedContent"
          aria-controls="navbarSupportedContent"
          aria-expanded="false"
          aria-label="Toggle navigation"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav mr-auto">
            <li class="nav-item">
              <router-link :to="{name: 'home'}" exact class="nav-link">Active</router-link>
            </li>
            <li class="nav-item">
              <router-link :to="{name: 'blocked'}" exact class="nav-link">Blocked</router-link>
            </li>
            <li class="nav-item">
              <router-link :to="{name: 'repos'}" exact class="nav-link">Repos</router-link>
            </li>
          </ul>
          <ul class="navbar-nav">
            <li class="nav-item" v-if="config_status">
              <a class="nav-link" v-bind:href="mojo_status_url" target="_blank">Status</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="https://github.com/openSUSE/qem-dashboard/blob/main/API.md" target="_blank">
                API
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <div class="container">
      <div class="row">
        <div class="col-md-12 title">
          <h2>{{ title }}</h2>
          Last updated <span class="from-now">{{ last_updated }}</span>
        </div>
      </div>

      <div class="row">
        <div class="col-md-12">
          <router-view></router-view>
        </div>
      </div>

      <a
        id="back-to-top"
        href="#"
        class="btn btn-primary btn-lg back-to-top"
        role="button"
        title="Click to return to the top"
      >
        <i class="fas fa-angle-up"></i>
      </a>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',
  data: function () {
    return {last_updated: 0};
  },
  computed: {
    // exported by mojo into the global head script
    config_status: function () {
      return config_status;
    },
    mojo_status_url: function () {
      return mojo_status_url;
    },
    title() {
      document.title = this.$route.meta.title;
      return this.$route.meta.title;
    }
  }
};
</script>
