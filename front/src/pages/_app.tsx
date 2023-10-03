import { Provider } from "@/lib/urql";
import { Outlet } from 'react-router-dom'

export default function App() {
  return <Provider>
    <div class="min-h-screen bg-base-100">
      <div class="container mx-auto max-w-5xl px-4 py-8">
        <Outlet />
      </div>
    </div>
  </Provider>
}