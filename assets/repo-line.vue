<template lang="html">
    <tr>
        <td>
            <div>{{ name }} </div>
            <div class="text-left">
                <button type="button" class="btn btn-primary btn-sm" v-on:click="triggerModal">
                  <span class="badge badge-primary">
                      {{ incident_number }}
                  </span> Incidents
              </button>
              </div>
        </td>
        <td>
            <ul class="summary-list">
                <li v-for="result in repo.summaries"
                    v-bind:result="result">
                    <result-summary v-bind:result="result"></result-summary>
                </li>
            </ul>
        </td>
    </tr>
</template>

<script>
module.exports = {
  props: ["repo", "name"],
  computed: {
      incident_number: function() {
          return this.repo.incidents.length;
      }
  },
  methods: {
      triggerModal: function() {
          let dialog = this.$root.$refs.incidentsDialog;
          dialog.title = this.name;
          dialog.incidents = this.repo.incidents;
          $('#update-incidents').modal('show')
          console.log(this.repo);
      }
  }
};
</script>
