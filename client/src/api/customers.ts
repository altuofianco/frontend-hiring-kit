// Importing constants.
import { API_BASE_URL } from "./constants";
const customersUrl = `${API_BASE_URL}/clienti`;

export async function fetchCustomers() {
  const response = await fetch(`${customersUrl}/elenco`);
  return response.json();
}
