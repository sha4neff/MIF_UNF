////////////////////////////////////////////////////////////////////////////////
// Подсистема УНФ "Организации".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию.
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецФункции

#КонецОбласти
