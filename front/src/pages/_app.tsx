import { Provider } from "@/lib/urql";
import { Outlet } from 'react-router-dom'
import { Suspense } from 'preact/compat'

export default function App() {
  return <Provider>
    <h1>Bike Bus</h1>
    <Suspense fallback={<h1>Loading...</h1>}>
      <Outlet />
    </Suspense>
  </Provider>
}