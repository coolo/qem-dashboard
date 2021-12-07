<template>
  <div class="incident-link">
    <a :href="smelt_link" target="_blank"> {{ incident.number }}:{{ package_name }} </a>
    <a v-if="incident.rr_number > 0" :href="obs_link" target="_blank" class="rr-link">
      <i class="fas fa-box" />
    </a>
  </div>
</template>

<script>
export default {
  name: 'SmeltLinkComponent',
  props: {incident: {type: Object, required: true}},
  computed: {
    obs_link: function () {
      return this.$obs_url + '/request/show/' + this.incident.rr_number;
    },
    smelt_link: function () {
      return this.$smelt_url + '/incident/' + this.incident.number;
    },
    package_name: function () {
      return this.incident.packages[0];
    }
  }
};
</script>
