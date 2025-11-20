// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import PostalCodeLookupController from "./postal_code_lookup_controller"
application.register("postal-code-lookup", PostalCodeLookupController)
