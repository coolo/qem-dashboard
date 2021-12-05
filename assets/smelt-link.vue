<template>
  <div class="incident-link">
    <a v-bind:href="smelt_link" target="_blank">
        {{incident.number}}:{{package_name}}
    </a>
    <a v-if="incident.rr_number > 0" v-bind:href="obs_link" target="_blank" class="rr-link">
      <i class="fas fa-box"></i>
    </a>
  </div>
</template>

<script>
module.exports = {
    props: ['incident'],
    computed: {
        obs_link: function() {
            return obs_url + "/request/show/" + this.incident.rr_number;
        },
        smelt_link: function() {
            return smelt_url + "/incident/" + this.incident.number;
        },
        package_name: function() {
            return this.incident.packages[0];
        }
    }
}
</script>