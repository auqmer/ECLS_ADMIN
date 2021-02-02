# Create ECLSK ef variable list
"""Creates list of variable names for R to extract variable from ECLSK"""
dcct = [for grade in range(1, 8): 'f x{grade}dccstot']
