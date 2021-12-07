<template>
  <div>
    <a :name="incident.number" />
    <router-link class="incident-link" :to="{name: 'incident', params: {id: incident.number}}">
      {{ incident.number }}:{{ package_name }}
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'IncidentLinkComponent',
  props: {incident: {type: Object, required: true}},
  computed: {
    package_name: function () {
      return this.incident.packages[0];
    }
  }
};
</script>
