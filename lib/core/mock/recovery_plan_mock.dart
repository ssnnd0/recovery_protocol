// Mock data for development and testing purposes
class RecoveryPlanMock {
  static final Map<String, dynamic> recoveryPlan = {
    "id": "plan_001",
    "title": "Post-Training Recovery Protocol",
    "duration": "25 mins",
    "difficulty": "Medium",
    "personalizationRationale": "Based on your recent high-intensity swim training and reported shoulder tension, this plan focuses on upper body recovery with gentle mobility work. Your sleep quality (7.2/10) and energy levels suggest moderate intensity exercises.",
    "learnMoreContent": "This AI-generated plan analyzes your training load from the past 7 days, wellness check-in data, and recovery patterns. The exercises target your primary stress areas while promoting blood flow and reducing muscle tension. Research shows that structured recovery protocols can improve performance by 15-20% and reduce injury risk by up to 40%.",
    "completionStatus": 0.0,
  };

  static final List<Map<String, dynamic>> exercises = [
    {
      "id": "ex_001",
      "name": "Shoulder Blade Squeezes",
      "duration": "3 mins",
      "thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      "targetAreas": ["Shoulders", "Upper Back"],
      "difficulty": "Easy",
      "equipment": ["None"],
      "description": "Gentle activation for shoulder stabilizers",
    },
    {
      "id": "ex_002",
      "name": "Cat-Cow Stretches",
      "duration": "4 mins",
      "thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
      "targetAreas": ["Spine", "Core"],
      "difficulty": "Easy",
      "equipment": ["None"],
      "description": "Spinal mobility and core activation",
    },
    {
      "id": "ex_003",
      "name": "Foam Roll - IT Band",
      "duration": "5 mins",
      "thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      "targetAreas": ["IT Band", "Legs"],
      "difficulty": "Medium",
      "equipment": ["Foam Roller"],
      "description": "Myofascial release for leg recovery",
    },
    {
      "id": "ex_004",
      "name": "Hip Flexor Stretches",
      "duration": "6 mins",
      "thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
      "targetAreas": ["Hip Flexors", "Legs"],
      "difficulty": "Easy",
      "equipment": ["None"],
      "description": "Deep hip mobility work",
    },
    {
      "id": "ex_005",
      "name": "Thoracic Spine Rotation",
      "duration": "4 mins",
      "thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      "targetAreas": ["Thoracic Spine", "Core"],
      "difficulty": "Medium",
      "equipment": ["None"],
      "description": "Rotational mobility for swimmers",
    },
    {
      "id": "ex_006",
      "name": "Breathing Meditation",
      "duration": "3 mins",
      "thumbnail": "https://images.unsplash.com/photo-1506629905607-d9c297d3d2f5?w=400&h=400&fit=crop",
      "targetAreas": ["Mind", "Recovery"],
      "difficulty": "Easy",
      "equipment": ["None"],
      "description": "Parasympathetic nervous system activation",
    },
  ];

  static final List<Map<String, dynamic>> alternativeExercises = [
    {
      "id": "alt_001",
      "name": "Wall Angels",
      "duration": "3 mins",
      "thumbnail": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=400&fit=crop",
      "targetAreas": ["Shoulders", "Upper Back"],
      "difficulty": "Easy",
      "equipment": ["None"],
    },
  ];
}
