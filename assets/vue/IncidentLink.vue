<template>
  <div>
    <a v-bind:name="incident.number" />
    <a class="incident-link" v-bind:href="incident_url">{{ incident.number }}:{{ package_name }}</a>
  </div>
</template>

<script>
export default {
  name: 'IncidentLinkComponent',
  props: ['incident'],
  computed: {
    incident_url: function () {
      return '/incident/' + this.incident.number;
    },
    package_name: function () {
      return this.incident.packages[0];
    }
  }
};
</script>
