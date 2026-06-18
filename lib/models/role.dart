enum Role {
  patient,
  medecin,
}

bool peutVoirListePatients(Role role) {
  return role == Role.medecin;
}

bool peutAjouterNoteConsultation(Role role) {
  return role == Role.medecin;
}

bool peutVoirHistoriqueComplet(Role role) {
  return role == Role.medecin;
}