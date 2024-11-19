using {flexso.htf as datamodel} from '../db/schema';

service ExplorationService {
    @readonly
    entity KnownGalaxies               as
        projection on DetailedGalaxiesView {
            key ID,
                name,
                distance,
                numberOfSolarSystems,
                averagePlanetsPerSolar,
                explorationReport,
                mostCommonStarType,
                mostCommonPlanetType,
                mostLikelyAlienType,
                numberOfPlanets,
                drakeScore as drakeEquation,
                AlienCivilisations    : Association to ContactedAlienCivilisations on AlienCivilisations.homeGalaxy.ID = $self.ID
        }

    @readonly
    entity ContactedAlienCivilisations as projection on datamodel.AlienCivilisations;

    @readonly
    entity KnownPlanetTypes            as projection on datamodel.PlanetTypes;

    @readonly
    entity KnownStarTypes              as projection on datamodel.StarTypes;

    @readonly
    entity KnownAlienTypes             as projection on datamodel.AlienTypes;

    @readonly
    entity KnownAlienStatus            as projection on datamodel.AlienStatus;
}

define view DetailedGalaxiesView 
    as select from datamodel.Galaxies as Galaxies
    left join datamodel.HabitableZones as Zones on Zones.starType = Galaxies.mostCommonStarType
    left join datamodel.CompabilityScores as Scores on Scores.planetType = Galaxies.mostCommonPlanetType
        and Scores.alienType = Galaxies.mostLikelyAlienType
    {
        key Galaxies.ID,
        Galaxies.name,
        Galaxies.distance,
        Galaxies.numberOfSolarSystems,
        Galaxies.averagePlanetsPerSolar,
        Galaxies.explorationReport,
        Galaxies.mostCommonStarType,
        Galaxies.mostCommonPlanetType,
        Galaxies.mostLikelyAlienType,
        Galaxies.numberOfSolarSystems * Galaxies.averagePlanetsPerSolar as numberOfPlanets : Double,
        case
            when Galaxies.numberOfSolarSystems * Galaxies.averagePlanetsPerSolar > 100000000000 THEN 1
            else 0.66
        end as baseDrakeScore : Double,
        (Zones.percentage * Scores.percentage * case
            when Galaxies.numberOfSolarSystems * Galaxies.averagePlanetsPerSolar > 100000000000 THEN 1
            else 0.66
        end * 100) as drakeScore : Double
    };
