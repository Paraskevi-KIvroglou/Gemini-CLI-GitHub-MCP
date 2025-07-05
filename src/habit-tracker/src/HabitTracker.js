import React, { useState, useEffect } from 'react';

const HabitTracker = () => {
  const [habits, setHabits] = useState([]);
  const [newHabit, setNewHabit] = useState('');

  useEffect(() => {
    const storedHabits = JSON.parse(localStorage.getItem('habits'));
    if (storedHabits) {
      setHabits(storedHabits);
    }
  }, []);

  useEffect(() => {
    localStorage.setItem('habits', JSON.stringify(habits));
  }, [habits]);

  const handleAddHabit = () => {
    if (newHabit.trim() !== '' && habits.length < 6) {
      setHabits([...habits, { name: newHabit, completed: {} }]);
      setNewHabit('');
    }
  };

  const handleDeleteHabit = (habitName) => {
    setHabits(habits.filter((habit) => habit.name !== habitName));
  };

  const handleToggleComplete = (habitName, day) => {
    const updatedHabits = habits.map((habit) => {
      if (habit.name === habitName) {
        return {
          ...habit,
          completed: {
            ...habit.completed,
            [day]: !habit.completed[day],
          },
        };
      }
      return habit;
    });
    setHabits(updatedHabits);
  };

  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  return (
    <div className="container mt-5">
      <h1 className="text-center mb-4">Habit Tracker</h1>
      <div className="input-group mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Add a new habit (up to 6)"
          value={newHabit}
          onChange={(e) => setNewHabit(e.target.value)}
        />
        <button className="btn btn-primary" onClick={handleAddHabit}>
          Add Habit
        </button>
      </div>

      <div className="row">
        {days.map((day) => (
          <div key={day} className="col">
            <div className="card">
              <div className="card-header text-center">{day}</div>
              <ul className="list-group list-group-flush">
                {habits.map((habit) => (
                  <li
                    key={habit.name}
                    className={`list-group-item d-flex justify-content-between align-items-center ${
                      habit.completed[day] ? 'list-group-item-success' : ''
                    }`}
                    onClick={() => handleToggleComplete(habit.name, day)}
                  >
                    {habit.name}
                    <button
                      className="btn btn-sm btn-danger"
                      onClick={(e) => {
                        e.stopPropagation();
                        handleDeleteHabit(habit.name);
                      }}
                    >
                      Delete
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default HabitTracker;
