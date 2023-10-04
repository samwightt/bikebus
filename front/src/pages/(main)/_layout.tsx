import { Link } from "@/router";
import { Outlet } from "react-router-dom";

export default function Layout() {
  return (
    <div>
      <p class="text-2xl mb-6">
        <Link to="/">Bike bus</Link>
      </p>
      <Outlet />
    </div>
  );
}
