// Importing dependencies.
import { useState, useEffect } from "react";

// Importing api.
import { fetchCustomers } from "../../api/customers";

// Importing scripts.
import formatDate from "../../utils/formatDate";

// Importing interfaces.
import type Customer from "../../interfaces/customer";

export default function Table() {
  const [page, setPage] = useState(1);
  const [limit, setLimit] = useState(10);
  const [customers, setCustomers] = useState([]);
  const [allCustomers, setAllCustomers] = useState([]);

  useEffect(() => {
    (async () => {
      const customersData = await fetchCustomers();
      setAllCustomers(customersData);
      setCustomers(customersData.slice(0, 10));
    })();
  }, []);

  const onLimitUpdate = (newLimit: number) => {
    setPage(1);
    setLimit(newLimit);
    setCustomers(allCustomers.slice(0, newLimit));
  };

  const onPageUpdate = (newPage: number) => {
    setPage(newPage);
    setCustomers(allCustomers.slice((newPage - 1) * limit, limit * newPage));
  };

  return (
    <>
      <table className="">
        <thead>
          <tr>
            <th>Nome</th>
            <th>Email</th>
            <th>Telefono</th>
            <th>Indirizzo</th>
            <th>Data creazione</th>
            <th>Data aggiornamento</th>
            <th>Azioni</th>
          </tr>
        </thead>
        <tbody>
          {customers.map((customer: Customer) => (
            <tr key={customer.id}>
              <td>{customer.name}</td>
              <td>{customer.email}</td>
              <td>{customer.phone}</td>
              <td>{customer.address}</td>
              <td>{formatDate(customer.created_at)}</td>
              <td>{formatDate(customer.updated_at)}</td>
              <td>
                <button>Modifica</button>
              </td>
              <td>
                <button>Elimina</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <select
        defaultValue="10"
        onChange={(event) => onLimitUpdate(Number(event.target.value))}
        name="limit"
        id="limit"
      >
        <option value="5"> 5 </option>
        <option value="10"> 10 </option>
        <option value="20"> 20 </option>
        <option value="50"> 50 </option>
      </select>

      <button onClick={() => onPageUpdate(page - 1)} disabled={page === 1}>
        {" "}
        {"<"}{" "}
      </button>
      <button
        onClick={() => onPageUpdate(page + 1)}
        disabled={page === Math.ceil(allCustomers.length / limit)}
      >
        {" >"}
      </button>
    </>
  );
}
