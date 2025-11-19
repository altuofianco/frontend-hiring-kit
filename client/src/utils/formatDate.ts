export default function formatDate(initialDate: string) {
  return new Date(initialDate).toLocaleDateString("it-IT");
}
