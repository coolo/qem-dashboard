<template>
  <div>
    <a v-bind:name="number" />
    <a class="incident-link" v-bind:href="incident_url">{{number}}:{{package_name}}</a>
  </div>
</template>

<script>
  module.exports = {
    props: ['incident'],
    computed: {
      incident_url: function() {
        return '/incident/' + this.incident.number;
      },
      package_name: function() {
        return this.incident.packages[0];
      },
      number: function() { return this.incident.number; }
    }
  }
</script>