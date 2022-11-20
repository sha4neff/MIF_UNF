
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Перем Заголовок;
	// Вставить содержимое обработчика.
	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("Организация, Ответственный, Подразделение, ВидПартии");

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	ИмяТабличнойЧасти = "ВыходныеИзделия";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("КлючИзделия, Номенклатура, Коэффициент, ЕдиницаИзмерения");

	// Вызовем общую процедуру для проверки проверки.
	ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);
	
	ИмяТабличнойЧасти = "Операции";

	// Укажем, что надо проверить:
	СтруктураОбязательныхПолей = 
	Новый Структура("КлючИзделия, ОперацияНомер, Операция, Участок");

	ИмяТабличнойЧасти = "ВыходныеИзделияИзБуфера";

	//// Укажем, что надо проверить:
	//СтруктураОбязательныхПолей = 
	//Новый Структура("КлючИзделия, Количество, ОперацияНачальная, УчастокНачальный,");

	//// Вызовем общую процедуру для проверки проверки.
	//ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);
	//
	// Вызовем общую процедуру для проверки проверки.
	//ЗаполнениеДокументов.ПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, ИмяТабличнойЧасти, СтруктураОбязательныхПолей, Отказ, Заголовок);
	Если Не Отказ Тогда
		//Для идентификации маршрутной карты по Номенлкатуре
		ПровестиПоРегистру_НезавершенноеПроизводство_Изделия(Отказ);   
		ПровестиПоРегистру_ОстаткиНаУчастках(Отказ);   
		ПровестиПоРегистру_ПланДвижения_Изделия(Отказ);   
		ПровестиПоРегистру_ПартииПроизводства_Параметры(Отказ);   
		Если Не Отказ Тогда
			Движения.Записать();	
		Иначе
			СтрокаСообщения = "Ошибка проведения документа "+ЭтотОбъект;
			ОбщегоНазначения.СообщитьОбОшибке(СтрокаСообщения, Отказ, "");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура	ПровестиПоРегистру_НезавершенноеПроизводство_Изделия(Отказ)
	// Вставить содержимое обработчика.
	БЗ_НезавершенноеПроизводство_Изделия = Движения.БЗ_НезавершенноеПроизводство_Изделия;
	БЗ_НезавершенноеПроизводство_Изделия.Записывать = Истина;	
	Для Каждого СТОперации Из Операции Цикл
		Движение=БЗ_НезавершенноеПроизводство_Изделия.Добавить();
		Движение.Активность = Истина;
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период=Дата;		
		Движение.КлючИзделия=СТОперации.КлючИзделия;	
		Движение.Номенклатура=СТОперации.Номенклатура;
		Движение.ХарактеристикаНоменклатуры=СТОперации.ХарактеристикаНоменклатуры;
		Движение.Участок=СТОперации.Участок;
		Движение.УчастокСледующий=СТОперации.УчастокСледующий;
		Движение.ВариантНаладки=СТОперации.ВариантНаладки;
		Движение.Операция=СТОперации.Операция;
		Движение.ОперацияНомер=СТОперации.ОперацияНомер;
		Движение.ОперацияСледующая=СТОперации.ОперацияСледующая;
		Движение.Статус=Перечисления.БЗ_СтатусыОстатковНаУчастке.План;
		Движение.Количество=СТОперации.Количество;
	КонецЦикла;		
КонецПроцедуры


Процедура	ПровестиПоРегистру_ОстаткиНаУчастках(Отказ)
	// Вставить содержимое обработчика.
	БЗ_ОстаткиНаУчастках = Движения.БЗ_ОстаткиНаУчастках;
	БЗ_ОстаткиНаУчастках.Записывать = Истина;	
	Для Каждого СТВИИзБуфера Из ВыходныеИзделияИзБуфера Цикл
		Если  ЗначениеЗаполнено(СТВИИзБуфера.НоменклатураИзБуфера) Тогда
			Движение=БЗ_ОстаткиНаУчастках.Добавить();
			Движение.Активность = Истина;
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период=Дата;		
			Движение.КлючИзделия=СТВИИзБуфера.КлючИзделияИзБуфера;	
			Движение.Номенклатура=СТВИИзБуфера.НоменклатураИзБуфера;
			Движение.ХарактеристикаНоменклатуры=СТВИИзБуфера.ХарактеристикаНоменклатурыИзБуфера;
			Движение.РабочееМесто=СТВИИзБуфера.РабочееМесто;
			Движение.ТЕ=СТВИИзБуфера.ТЕ;
			Движение.Участок=СТВИИзБуфера.УчастокНачальный;
			Движение.Операция=СТВИИзБуфера.ОперацияНачальная;
			Движение.Статус=Перечисления.БЗ_СтатусыОстатковНаУчастке.Хранение;
			Движение.Резерв=СТВИИзБуфера.Количество;
		КонецЕсли;
	КонецЦикла;		
КонецПроцедуры


Процедура	ПровестиПоРегистру_ПланДвижения_Изделия(Отказ)
	// Вставить содержимое обработчика.
	ПланДвижения_Изделия = Движения.БЗ_ПланДвижения_Изделия;
	ПланДвижения_Изделия.Записывать = Истина;	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия КАК КлючИзделияПоложить,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура КАК НоменклатураПоложить,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатурыПоложить,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияНачальная КАК Операция,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.УчастокНачальный КАК Участок,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.КлючИзделияИзБуфера КАК КлючИзделияВзять,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.НоменклатураИзБуфера КАК НоменклатураВзять,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.ХарактеристикаНоменклатурыИзБуфера КАК ХарактеристикаНоменклатурыВзять,
		|	СУММА(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.Количество) КАК Количество,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка КАК Регистратор,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.Дата КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	ЗНАЧЕНИЕ(Перечисление.БЗ_ТСД_ВидыДействий.Взять) КАК ВидДействия,
		|	ИСТИНА КАК Активность
		|ПОМЕСТИТЬ ДвиженияВзять
		|ИЗ
		|	Документ.БЗ_МаршрутныйЛистПроизводства.ВыходныеИзделия КАК БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.БЗ_МаршрутныйЛистПроизводства.ВыходныеИзделияИзБуфера КАК БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера
		|		ПО БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия = БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.КлючИзделия
		|			И БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияНачальная = БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.ОперацияНачальная
		|			И БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.УчастокНачальный = БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.УчастокНачальный
		|ГДЕ
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияНачальная <> ЗНАЧЕНИЕ(Справочник.БЗ_ТехнологическиеОперации.ПустаяСсылка)
		|	И БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.НоменклатураИзБуфера,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.КлючИзделияИзБуфера,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделияИзБуфера.ХарактеристикаНоменклатурыИзБуфера,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияНачальная,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.УчастокНачальный,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка КАК Регистратор,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия КАК КлючИзделияВзять,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура КАК НоменклатураВзять,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатурыВзять,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияКонечная КАК Операция,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.УчастокКонечный КАК Участок,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура КАК НоменклатураПоложить,
		|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка) КАК ХарактеристикаНоменклатурыПоложить,
		|	""                                    "" КАК КлючИзделияПоложить,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Количество КАК Количество,
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.Дата КАК Период,
		|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
		|	ЗНАЧЕНИЕ(Перечисление.БЗ_ТСД_ВидыДействий.Положить) КАК ВидДействия,
		|	ИСТИНА КАК Активность
		|ПОМЕСТИТЬ ДвиженияПоложить
		|ИЗ
		|	Документ.БЗ_МаршрутныйЛистПроизводства.ВыходныеИзделия КАК БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия
		|ГДЕ
		|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ОперацияКонечная <> ЗНАЧЕНИЕ(Справочник.БЗ_ТехнологическиеОперации.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияВзять.КлючИзделияПоложить КАК КлючИзделияПоложить,
		|	ДвиженияВзять.НоменклатураПоложить КАК НоменклатураПоложить,
		|	ДвиженияВзять.ХарактеристикаНоменклатурыПоложить КАК ХарактеристикаНоменклатурыПоложить,
		|	ДвиженияВзять.Операция КАК Операция,
		|	ДвиженияВзять.Участок КАК Участок,
		|	ДвиженияВзять.КлючИзделияВзять КАК КлючИзделияВзять,
		|	ДвиженияВзять.НоменклатураВзять КАК НоменклатураВзять,
		|	ДвиженияВзять.ХарактеристикаНоменклатурыВзять КАК ХарактеристикаНоменклатурыВзять,
		|	ДвиженияВзять.Количество КАК Количество,
		|	ДвиженияВзять.Регистратор КАК Регистратор,
		|	ДвиженияВзять.Период КАК Период,
		|	ДвиженияВзять.ВидДвижения КАК ВидДвижения,
		|	ДвиженияВзять.ВидДействия КАК ВидДействия,
		|	ДвиженияВзять.Активность КАК Активность
		|ИЗ
		|	ДвиженияВзять КАК ДвиженияВзять
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДвиженияПоложить.КлючИзделияПоложить,
		|	ДвиженияПоложить.НоменклатураПоложить,
		|	ДвиженияПоложить.ХарактеристикаНоменклатурыПоложить,
		|	ДвиженияПоложить.Операция,
		|	ДвиженияПоложить.Участок,
		|	ДвиженияПоложить.КлючИзделияВзять,
		|	ДвиженияПоложить.НоменклатураВзять,
		|	ДвиженияПоложить.ХарактеристикаНоменклатурыВзять,
		|	ДвиженияПоложить.Количество,
		|	ДвиженияПоложить.Регистратор,
		|	ДвиженияПоложить.Период,
		|	ДвиженияПоложить.ВидДвижения,
		|	ДвиженияПоложить.ВидДействия,
		|	ДвиженияПоложить.Активность
		|ИЗ
		|	ДвиженияПоложить КАК ДвиженияПоложить";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	ТЗДвижений = Запрос.Выполнить().Выгрузить();
	
	ПланДвижения_Изделия.Загрузить(ТЗДвижений);
	
КонецПроцедуры


Процедура	ПровестиПоРегистру_ПартииПроизводства_Параметры(Отказ)
	// Вставить содержимое обработчика.
	БЗ_ПартииПроизводства_Параметры = Движения.БЗ_ПартииПроизводства_Параметры;
	БЗ_ПартииПроизводства_Параметры.Записывать = Истина;	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
"ВЫБРАТЬ
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка) КАК МаршрутныйЛист,
|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия КАК КлючИзделия,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ЗаказНаПроизводство) КАК ЗаказНаПроизводство,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура) КАК Номенклатура,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ХарактеристикаНоменклатуры) КАК ХарактеристикаНоменклатуры,
|	СУММА(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Количество) КАК Количество,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Коэффициент) КАК Коэффициент,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.ЕдиницаИзмерения) КАК ЕдиницаИзмерения,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Кратность) КАК Кратность,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.МаршрутнаяКарта) КАК МаршрутнаяКарта,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.ВидПартии) КАК ВидПартии,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.Организация) КАК Организация,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.Подразделение) КАК Подразделение,
|	МАКСИМУМ(БЗ_Резка.Ссылка) КАК Резка,
|	МАКСИМУМ(БЗ_РасчетРезки.Ссылка) КАК РасчетРезки,
|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия КАК КлючПартии,
|	МАКСИМУМ(БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Номенклатура.НоменклатурнаяГруппаТорговля) КАК НоменклатурнаяГруппа
|ПОМЕСТИТЬ КлючиПартии
|ИЗ
|	Документ.БЗ_МаршрутныйЛистПроизводства.ВыходныеИзделия КАК БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_РасчетРезки КАК БЗ_РасчетРезки
|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.БЗ_Резка КАК БЗ_Резка
|			ПО БЗ_РасчетРезки.Ссылка = БЗ_Резка.РасчетРезки
|		ПО БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка.РасчетРезки = БЗ_РасчетРезки.Ссылка
|ГДЕ
|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.Ссылка = &Ссылка
|
|СГРУППИРОВАТЬ ПО
|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия,
|	БЗ_МаршрутныйЛистПроизводстваВыходныеИзделия.КлючИзделия
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	КлючиПартии.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
|	КлючиПартии.Номенклатура КАК Номенклатура
|ПОМЕСТИТЬ Единицы
|ИЗ
|	КлючиПартии КАК КлючиПартии
|
|СГРУППИРОВАТЬ ПО
|	КлючиПартии.ЕдиницаИзмерения,
|	КлючиПартии.Номенклатура
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	Единицы.Номенклатура КАК Номенклатура,
|	Единицы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
|	Единицы.ЕдиницаИзмерения.Ширина КАК РазмерX,
|	Единицы.ЕдиницаИзмерения.Высота КАК РазмерY,
|	Единицы.ЕдиницаИзмерения.Глубина КАК РазмерZ,
|	Единицы.ЕдиницаИзмерения.Вес КАК Вес,
|	Единицы.ЕдиницаИзмерения.Объем КАК Объем,
|	Единицы.ЕдиницаИзмерения.Ширина * Единицы.ЕдиницаИзмерения.Высота / 1000000 КАК Площадь,
|	ВЫБОР
|		КОГДА Единицы.Номенклатура.ВидФрезеровки = ЗНАЧЕНИЕ(Перечисление.НП_ВидыФрезеровки.ПустаяСсылка)
|			ТОГДА Единицы.Номенклатура.НоменклатурнаяГруппаТорговля.ВидФрезеровки
|		ИНАЧЕ Единицы.Номенклатура.ВидФрезеровки
|	КОНЕЦ КАК ВидФрезеровки
|ПОМЕСТИТЬ ПараметрыЕдиниц
|ИЗ
|	Единицы КАК Единицы
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	КлючиПартии.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры
|ПОМЕСТИТЬ ХарактеристикиНоменклатуры
|ИЗ
|	КлючиПартии КАК КлючиПартии
|
|СГРУППИРОВАТЬ ПО
|	КлючиПартии.ХарактеристикаНоменклатуры
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	Характеристики.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	ЗначенияСвойствОбъектовЦвет.Значение КАК Цвет
|ПОМЕСТИТЬ ПараметрыЦвет
|ИЗ
|	ХарактеристикиНоменклатуры КАК Характеристики
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовЦвет
|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектовЦвет
|			ПО ЗначенияСвойствОбъектовЦвет.Свойство = СвойстваОбъектовЦвет.Ссылка
|		ПО Характеристики.ХарактеристикаНоменклатуры = ЗначенияСвойствОбъектовЦвет.Объект
|ГДЕ
|	СвойстваОбъектовЦвет.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры)
|	И СвойстваОбъектовЦвет.Наименование = ""Цвет""
|
|СГРУППИРОВАТЬ ПО
|	ЗначенияСвойствОбъектовЦвет.Значение,
|	Характеристики.ХарактеристикаНоменклатуры
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	Характеристики.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	ЗначенияСвойствОбъектовБренд.Значение КАК Бренд
|ПОМЕСТИТЬ ПараметрыБренд
|ИЗ
|	ХарактеристикиНоменклатуры КАК Характеристики
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗначенияСвойствОбъектов КАК ЗначенияСвойствОбъектовБренд
|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.СвойстваОбъектов КАК СвойстваОбъектовБренд
|			ПО ЗначенияСвойствОбъектовБренд.Свойство = СвойстваОбъектовБренд.Ссылка
|		ПО Характеристики.ХарактеристикаНоменклатуры = ЗначенияСвойствОбъектовБренд.Объект
|ГДЕ
|	СвойстваОбъектовБренд.НазначениеСвойства = ЗНАЧЕНИЕ(ПланВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_ХарактеристикиНоменклатуры)
|	И СвойстваОбъектовБренд.Наименование = ""Бренд""
|
|СГРУППИРОВАТЬ ПО
|	ЗначенияСвойствОбъектовБренд.Значение,
|	Характеристики.ХарактеристикаНоменклатуры
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	КлючиПартии.КлючПартии КАК КлючПартии,
|	КлючиПартии.РасчетРезки КАК РасчетРезки,
|	КлючиПартии.МаршрутныйЛист КАК МаршрутныйЛист,
|	КлючиПартии.Резка КАК Резка,
|	КлючиПартии.ЗаказНаПроизводство КАК ЗаказНаПроизводство,
|	КлючиПартии.Организация КАК Организация,
|	КлючиПартии.Подразделение КАК Подразделение,
|	КлючиПартии.Номенклатура КАК Номенклатура,
|	КлючиПартии.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
|	КлючиПартии.Количество КАК Количество,
|	КлючиПартии.Коэффициент КАК Коэффициент,
|	КлючиПартии.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
|	КлючиПартии.Кратность КАК Кратность,
|	КлючиПартии.МаршрутнаяКарта КАК МаршрутнаяКарта,
|	КлючиПартии.ВидПартии КАК ВидПартии,
|	ПараметрыЕдиниц.РазмерX КАК РазмерX,
|	ПараметрыЕдиниц.РазмерY КАК РазмерY,
|	ПараметрыЕдиниц.РазмерZ КАК РазмерZ,
|	КлючиПартии.Количество * КлючиПартии.Коэффициент * ПараметрыЕдиниц.Вес КАК Вес,
|	КлючиПартии.Количество * КлючиПартии.Коэффициент * ПараметрыЕдиниц.Объем КАК Объем,
|	КлючиПартии.Количество * КлючиПартии.Коэффициент * ПараметрыЕдиниц.Площадь КАК Площадь,
|	ПараметрыЕдиниц.ВидФрезеровки КАК ВидФрезеровки,
|	ПараметрыЦвет.Цвет КАК Цвет,
|	ПараметрыБренд.Бренд КАК Бренд,
|	КлючиПартии.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа
|ИЗ
|	КлючиПартии КАК КлючиПартии
|		ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыЕдиниц КАК ПараметрыЕдиниц
|		ПО КлючиПартии.ЕдиницаИзмерения = ПараметрыЕдиниц.ЕдиницаИзмерения
|		ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыЦвет КАК ПараметрыЦвет
|		ПО КлючиПартии.ХарактеристикаНоменклатуры = ПараметрыЦвет.ХарактеристикаНоменклатуры
|		ЛЕВОЕ СОЕДИНЕНИЕ ПараметрыБренд КАК ПараметрыБренд
|		ПО КлючиПартии.ХарактеристикаНоменклатуры = ПараметрыБренд.ХарактеристикаНоменклатуры";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Параметры = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Параметр Из Параметры Цикл
		Движение=БЗ_ПартииПроизводства_Параметры.Добавить();
		Движение.Активность = Истина;
		Движение.Период=Дата;
		ЗаполнитьЗначенияСвойств(Движение, Параметр);
	КонецЦикла;		
КонецПроцедуры

