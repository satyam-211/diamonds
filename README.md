# Diamond Selection App

A Flutter application that allows users to browse, filter, sort, and purchase diamonds with a persistent shopping cart experience.

## Project Structure

The project follows a clean architecture approach with a clear separation of concerns:

```
lib/
├── data/
│   └── data.dart             # Contains the diamonds dataset
├── models/
│   └── diamond.dart          # Diamond model class
├── repositories/
│   ├── diamond_repository.dart  # Provides access to diamond data
│   └── cart_repository.dart     # Handles cart persistence
├── blocs/
│   ├── filter_bloc.dart      # Manages filter state and logic
│   ├── diamond_bloc.dart     # Handles diamond list filtering and sorting
│   └── cart_bloc.dart        # Manages cart operations and persistence
├── presentation/pages
│   ├── filter_page.dart      # Filter selection UI
│   ├── result_page.dart      # Filtered diamonds display
│   └── cart_page.dart        # Shopping cart UI
└── main.dart                 # App entry point and BLoC providers
```

### Key Components

1. **Models**: Defines the data structures used throughout the app
    - `Diamond`: Represents a diamond with all its properties

2. **Repositories**: Acts as data sources for the BLoCs
    - `DiamondRepository`: Provides access to diamond data and filter options
    - `CartRepository`: Handles persistence of cart data

3. **BLoCs**: Manages business logic and state
    - `FilterBloc`: Handles the state of filter criteria
    - `DiamondBloc`: Manages diamond data, filtering, and sorting
    - `CartBloc`: Handles cart operations and summary calculations

4. **Presentation**: UI components
    - `FilterPage`: Allow users to select filtering criteria
    - `ResultPage`: Displays filtered diamonds with sorting options
    - `CartPage`: Shows cart contents and summary information

## State Management Logic

The app uses the BLoC pattern with sealed classes for type-safe state management:

### BLoC Architecture

Each BLoC follows a similar pattern:
- **Events**: Input actions that trigger state changes (sealed classes)
- **States**: Output representations of the UI state (sealed classes)
- **BLoC**: Handles events and emits new states

### FilterBloc

**Events**:
- `FilterUpdated`: Updates filter values
- `FilterReset`: Resets filters to default
- `FilterApplied`: Marks filters as applied

**States**:
- `FilterInitial`: Initial state
- `FilterLoading`: Loading state
- `FilterLoaded`: Contains current filter values

### DiamondBloc

**Events**:
- `DiamondLoadRequested`: Loads all diamonds
- `DiamondFilterOptionsRequested`: Fetches filter dropdown options
- `DiamondFiltered`: Applies filters to diamonds
- `DiamondSorted`: Sorts diamonds by price or carat

**States**:
- `DiamondInitial`: Initial state
- `DiamondLoading`: Loading state
- `DiamondLoaded`: Contains lists of all and filtered diamonds
- `DiamondError`: Represents an error state

### CartBloc

**Events**:
- `CartStarted`: Initializes the cart
- `CartItemAdded`: Adds a diamond to cart
- `CartItemRemoved`: Removes a diamond from cart
- `CartCleared`: Clears all diamonds from cart

**States**:
- `CartInitial`: Initial state
- `CartLoading`: Loading state
- `CartLoaded`: Contains cart items and summary data
- `CartError`: Represents an error state

### Data Flow

1. User interacts with UI (e.g., selects filters)
2. UI dispatches events to BLoCs
3. BLoCs process events and update state
4. UI rebuilds based on new state

## Persistent Storage Usage

The app uses `shared_preferences` for local persistence of cart data.

### Cart Persistence Implementation

The `CartRepository` handles all persistence operations:

1. **Saving Cart**:
    - Converts Diamond objects to JSON
    - Stores serialized data using SharedPreferences

2. **Loading Cart**:
    - Retrieves JSON data from SharedPreferences
    - Deserializes data back to Diamond objects

3. **Clearing Cart**:
    - Removes cart data from SharedPreferences

### Persistence Flow

1. `CartBloc` initializes by loading saved cart from `CartRepository`
2. When cart items change, `CartBloc` updates the state and saves to storage
3. On app restart, saved cart items are loaded automatically

## Feature Highlights

- **Filtering**: Multiple filter criteria with intuitive UI
- **Sorting**: Price and carat weight sorting in ascending/descending order
- **Cart Management**: Add/remove diamonds with swipe-to-delete functionality
- **Summary Statistics**: Total carat, price, and average calculations
- **Persistent Storage**: Cart remains intact even after app restart

## Dependencies

- `flutter_bloc`: For BLoC state management
- `equatable`: For value equality comparisons
- `shared_preferences`: For local persistence storage

## Installation and Setup

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app