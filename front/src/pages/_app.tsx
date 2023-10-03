import { Provider } from "@/lib/urql";
import { Outlet } from 'react-router-dom'

export default function App() {
  return <Provider>
    <Outlet />
  </Provider>
}